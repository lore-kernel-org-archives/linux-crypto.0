From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] KEYS: Fix for erroneous trust of incorrectly signed
 X.509 certs
Date: Mon, 18 Jul 2016 00:10:55 +0100
Message-ID: <146879705531.32133.1521913202035295780.stgit@warthog.procyon.org.uk>
References: <146879703192.32133.3670984393495441516.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: keyring@vger.kernel.org, Petko Manolov <petkan@mip-labs.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146879703192.32133.3670984393495441516.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

Arbitrary X.509 certificates without authority key identifiers (AKIs)
can be added to "trusted" keyrings, including IMA or EVM certs loaded
from the filesystem. Signature verification is currently bypassed for
certs without AKIs.

Trusted keys were recently refactored, and this bug is not present in
4.6.

restrict_link_by_signature should return -ENOKEY (no matching parent
certificate found) if the certificate being evaluated has no AKIs,
instead of bypassing signature checks and returning 0 (new certificate
accepted).

Reported-by: Petko Manolov <petkan@mip-labs.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/restrict.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index ac4bddf669de..19d1afb9890f 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -87,7 +87,7 @@ int restrict_link_by_signature(struct key *trust_keyring,
 
 	sig = payload->data[asym_auth];
 	if (!sig->auth_ids[0] && !sig->auth_ids[1])
-		return 0;
+		return -ENOKEY;
 
 	if (ca_keyid && !asymmetric_key_id_partial(sig->auth_ids[1], ca_keyid))
 		return -EPERM;
