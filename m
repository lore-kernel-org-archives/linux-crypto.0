From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/10] KEYS: Add facility to check key trustworthiness upon
 link creation
Date: Wed, 21 Oct 2015 16:13:43 +0100
Message-ID: <20151021151343.4583.30345.stgit@warthog.procyon.org.uk>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a facility whereby if KEY_FLAG_TRUSTED_ONLY is set on the destination
keyring, the creation of a link to a candidate key will cause the
trustworthiness of that key to be evaluated against the already present
contents of that keyring.  This affects operations like add_key(),
KEYCTL_LINK and KEYCTL_INSTANTIATE.

To this end:

 (1) A new key type method is provided:

	int (*verify_trust)(const union key_payload *payload,
			    struct key *keyring);

     This is implemented by key types for which verification of one key by
     another is appropriate.  It is primarily intended for use with the
     asymmetric key type.

     When called, it is given the payload or prospective payload[*] of the
     candidate key to verify and a pointer to the destination keyring.  The
     method is expected to search the keying for an appropriate key with
     which to verify the candidate.

     [*] If called during add_key(), preparse is called before this method,
     	 but a key isn't actually allocated unless the verification is
     	 successful.

 (2) KEY_FLAG_TRUSTED is removed.  A key is now trusted by virtue of being
     contained in the trusted-only keyring being searched.

 (3) KEY_ALLOC_TRUSTED now acts as an override.  If this is passed to
     key_create_or_update() then the ->verify_trust() method will be
     ignored and the key will be added anyway.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt          |   17 ++++++++++++
 crypto/asymmetric_keys/x509_public_key.c |    6 ++--
 include/linux/key-type.h                 |   10 ++++++-
 include/linux/key.h                      |   12 +++++---
 security/keys/key.c                      |   44 ++++++++++++++++++++++++------
 security/keys/keyring.c                  |   18 +++++++++++-
 6 files changed, 87 insertions(+), 20 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 8c183873b2b7..e7f3447ccd1b 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -1183,6 +1183,23 @@ The structure has a number of fields, some of which are mandatory:
      successfully, even if instantiate() or update() succeed.
 
 
+ (*) int (*verify_trust)(const union key_payload *payload, struct key *keyring);
+
+     If the keyring to which a candidate key is being added/linked is marked as
+     KEY_FLAG_TRUSTED_ONLY then this function will get called in the candidate
+     key type to verify the key or proposed key based on its payload.  It is
+     expected to use the contents of the supplied destination keyring to
+     determine whether the candidate key is to be trusted and added to the
+     keyring.
+
+     The method should return 0 to allow the addition and an error otherwise,
+     typically ENOKEY if there's no key in the keyring to verify this key and
+     EKEYREJECTED if the selected key fails to verify the candidate.
+
+     This method is optional.  If it is not supplied, keys of this type cannot
+     be added to trusted-only keyrings and EPERM will be returned.
+
+
  (*) int (*instantiate)(struct key *key, struct key_preparsed_payload *prep);
 
      This method is called to attach a payload to a key during construction.
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 64d42981a8d7..76c211b31da7 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -318,10 +318,10 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
-	} else if (!prep->trusted) {
+	} else {
 		ret = x509_validate_trust(cert, get_system_trusted_keyring());
-		if (!ret)
-			prep->trusted = 1;
+		if (ret == -EKEYREJECTED)
+			goto error_free_cert;
 	}
 
 	/* Propose a description */
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 7463355a198b..5d7cf5e7f8c6 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -45,7 +45,6 @@ struct key_preparsed_payload {
 	size_t		datalen;	/* Raw datalen */
 	size_t		quotalen;	/* Quota length for proposed payload */
 	time_t		expiry;		/* Expiry time of key */
-	bool		trusted;	/* True if key is trusted */
 };
 
 typedef int (*request_key_actor_t)(struct key_construction *key,
@@ -95,6 +94,15 @@ struct key_type {
 	 */
 	void (*free_preparse)(struct key_preparsed_payload *prep);
 
+	/* Verify the trust on a key when added to a trusted-only keyring.
+	 *
+	 * If this method isn't provided then it is assumed that the concept of
+	 * trust is irrelevant to keys of this type and an attempt to add one
+	 * to a trusted-only keyring will be rejected.
+	 */
+	int (*verify_trust)(const union key_payload *payload,
+			    struct key *keyring);
+
 	/* instantiate a key of this type
 	 * - this method should call key_payload_reserve() to determine if the
 	 *   user's quota will hold the payload
diff --git a/include/linux/key.h b/include/linux/key.h
index 66f705243985..19cb9283448a 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -173,10 +173,12 @@ struct key {
 #define KEY_FLAG_NEGATIVE	5	/* set if key is negative */
 #define KEY_FLAG_ROOT_CAN_CLEAR	6	/* set if key can be cleared by root without permission */
 #define KEY_FLAG_INVALIDATED	7	/* set if key has been invalidated */
-#define KEY_FLAG_TRUSTED	8	/* set if key is trusted */
-#define KEY_FLAG_TRUSTED_ONLY	9	/* set if keyring only accepts links to trusted keys */
-#define KEY_FLAG_BUILTIN	10	/* set if key is builtin */
-#define KEY_FLAG_ROOT_CAN_INVAL	11	/* set if key can be invalidated by root without permission */
+#define KEY_FLAG_TRUSTED_ONLY	8	/* set to make keyring only accept links to keys that can
+					 * be verified by one of the keys it already contains or
+					 * if KEY_ALLOC_TRUSTED is flagged.
+					 */
+#define KEY_FLAG_BUILTIN	9	/* set if key is builtin */
+#define KEY_FLAG_ROOT_CAN_INVAL	10	/* set if key can be invalidated by root without permission */
 
 	/* the key type and key description string
 	 * - the desc is used to match a key against search criteria
@@ -217,7 +219,7 @@ extern struct key *key_alloc(struct key_type *type,
 #define KEY_ALLOC_IN_QUOTA	0x0000	/* add to quota, reject if would overrun */
 #define KEY_ALLOC_QUOTA_OVERRUN	0x0001	/* add to quota, permit even if overrun */
 #define KEY_ALLOC_NOT_IN_QUOTA	0x0002	/* not in quota */
-#define KEY_ALLOC_TRUSTED	0x0004	/* Key should be flagged as trusted */
+#define KEY_ALLOC_TRUSTED	0x0004	/* Override the verification check on trusted keyrings */
 
 extern void key_revoke(struct key *key);
 extern void key_invalidate(struct key *key);
diff --git a/security/keys/key.c b/security/keys/key.c
index ab7997ded725..e081e3921397 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -294,8 +294,6 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
 		key->flags |= 1 << KEY_FLAG_IN_QUOTA;
-	if (flags & KEY_ALLOC_TRUSTED)
-		key->flags |= 1 << KEY_FLAG_TRUSTED;
 
 #ifdef KEY_DEBUGGING
 	key->magic = KEY_DEBUG_MAGIC;
@@ -478,6 +476,11 @@ int key_instantiate_and_link(struct key *key,
 	struct assoc_array_edit *edit;
 	int ret;
 
+	if (keyring &&
+	    unlikely(test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags)) &&
+	    !key->type->verify_trust)
+		return -EPERM;
+
 	memset(&prep, 0, sizeof(prep));
 	prep.data = data;
 	prep.datalen = datalen;
@@ -490,6 +493,13 @@ int key_instantiate_and_link(struct key *key,
 	}
 
 	if (keyring) {
+		if (unlikely(test_bit(KEY_FLAG_TRUSTED_ONLY,
+				      &keyring->flags)) &&
+		    key->type->verify_trust) {
+			ret = key->type->verify_trust(&prep.payload, keyring);
+			if (ret < 0)
+				goto error;
+		}
 		ret = __key_link_begin(keyring, &key->index_key, &edit);
 		if (ret < 0)
 			goto error;
@@ -545,8 +555,12 @@ int key_reject_and_link(struct key *key,
 	awaken = 0;
 	ret = -EBUSY;
 
-	if (keyring)
+	if (keyring) {
+		if (unlikely(test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags)))
+			return -EPERM;
+
 		link_ret = __key_link_begin(keyring, &key->index_key, &edit);
+	}
 
 	mutex_lock(&key_construction_mutex);
 
@@ -786,6 +800,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	const struct cred *cred = current_cred();
 	struct key *keyring, *key = NULL;
 	key_ref_t key_ref;
+	bool verify_trust;
 	int ret;
 
 	/* look up the key type to see if it's one of the registered kernel
@@ -802,9 +817,18 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		goto error_put_type;
 
 	keyring = key_ref_to_ptr(keyring_ref);
-
 	key_check(keyring);
 
+	key_ref = ERR_PTR(-EPERM);
+	if (!test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags))
+		verify_trust = false;
+	else if (flags & KEY_ALLOC_TRUSTED)
+		verify_trust = false;
+	else if (index_key.type->verify_trust)
+		verify_trust = true;
+	else
+		goto error_put_type;
+
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -813,7 +837,6 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	prep.data = payload;
 	prep.datalen = plen;
 	prep.quotalen = index_key.type->def_datalen;
-	prep.trusted = flags & KEY_ALLOC_TRUSTED;
 	prep.expiry = TIME_T_MAX;
 	if (index_key.type->preparse) {
 		ret = index_key.type->preparse(&prep);
@@ -829,10 +852,13 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 	index_key.desc_len = strlen(index_key.description);
 
-	key_ref = ERR_PTR(-EPERM);
-	if (!prep.trusted && test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags))
-		goto error_free_prep;
-	flags |= prep.trusted ? KEY_ALLOC_TRUSTED : 0;
+	if (verify_trust) {
+		ret = index_key.type->verify_trust(&prep.payload, keyring);
+		if (ret < 0) {
+			key_ref = ERR_PTR(ret);
+			goto error_free_prep;
+		}
+	}
 
 	ret = __key_link_begin(keyring, &index_key, &edit);
 	if (ret < 0) {
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index f931ccfeefb0..01aa3837644a 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1191,6 +1191,18 @@ void __key_link_end(struct key *keyring,
 	up_write(&keyring->sem);
 }
 
+/*
+ * Verify a trusted-only keyring link.
+ */
+static int __key_link_verify(struct key *keyring, struct key *key)
+{
+	if (!test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags))
+		return 0;
+	if (!key->type->verify_trust)
+		return -EPERM;
+	return key->type->verify_trust(&key->payload, keyring);
+}
+
 /**
  * key_link - Link a key to a keyring
  * @keyring: The keyring to make the link in.
@@ -1222,13 +1234,15 @@ int key_link(struct key *keyring, struct key *key)
 	key_check(key);
 
 	if (test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags) &&
-	    !test_bit(KEY_FLAG_TRUSTED, &key->flags))
+	    !key->type->verify_trust)
 		return -EPERM;
 
 	ret = __key_link_begin(keyring, &key->index_key, &edit);
 	if (ret == 0) {
 		kdebug("begun {%d,%d}", keyring->serial, atomic_read(&keyring->usage));
-		ret = __key_link_check_live_key(keyring, key);
+		ret = __key_link_verify(keyring, key);
+		if (ret == 0)
+			ret = __key_link_check_live_key(keyring, key);
 		if (ret == 0)
 			__key_link(key, &edit);
 		__key_link_end(keyring, &key->index_key, edit);
