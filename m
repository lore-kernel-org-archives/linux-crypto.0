From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Mon, 15 Nov 2010 16:18:54 +0000
Message-ID: <8268.1289837934@redhat.com>
References: <1289694826.3257.82.camel@localhost.localdomain> <1289595738.2731.80.camel@localhost.localdomain> <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0KOQTV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 11:19:21 -0500
In-Reply-To: <1289694826.3257.82.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > I thought that might be the case.  In which case, it might be better to
> > allow someone to add a trusted key, supplying both encrypted and
> > unencrypted versions of the data so that the TPM need not be consulted.
> > You might want to mark such a key so that it can be seen when it is
> > dumped.
> 
> At least to me, the name 'trusted' implies some form of HW. 

In many ways, I think that the type and description describe the purpose of
the key, not its source or derivation.

> > But if you're going to use a user-defined key, you really need to prefix
> > the description with something suitable.
> 
> Agreed. So instead of: 
> 	keyctl add encrypted name "new master-key-name keylen" ring
> 
> the description would be prefixed with the key type like:	
> 	keyctl add encrypted name "new trusted|user master-key-name keylen" ring

I don't think you understood what I meant.  If you look at the following
function:

+static struct key *request_master_key(struct encrypted_key_payload *epayload,
+	       	   			void **master_key,
+					unsigned int *master_keylen)
+{
+	struct key *mkey;
+
+	mkey = request_trusted_key(epayload->master_desc,
+				   master_key, master_keylen);
+	if (IS_ERR(mkey)) {
+		mkey = request_user_key(epayload->master_desc,
+					master_key, master_keylen);
+		if (IS_ERR(mkey)) {
+			pr_info("encrypted_key: trusted/user key %s not found",
+				epayload->master_desc);
+			return mkey;
+		}
+	}
+	dump_master_key(*master_key, *master_keylen);
+	return mkey;
+}

In the bit where you go for a user key (having failed to get a trusted key),
you should prefix the description here (or in request_user_key()) with
something like "trusted:".  Then you don't need to change the user interface.

David
