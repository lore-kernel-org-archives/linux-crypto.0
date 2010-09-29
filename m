From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 4/4] keys: add new key-type encrypted
Date: Wed, 29 Sep 2010 09:43:38 -0400
Message-ID: <1285767818.3213.46.camel@localhost.localdomain>
References: <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <201009291200.47199.roberto.sassu@polito.it>
	 <1285761456.4350.11.camel@localhost.localdomain>
	 <201009291440.59445.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46722 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0I2Nnz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Sep 2010 09:43:55 -0400
In-Reply-To: <201009291440.59445.roberto.sassu@polito.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2010-09-29 at 14:40 +0200, Roberto Sassu wrote:
> On Wednesday, September 29, 2010 01:57:36 pm Mimi Zohar wrote:
> > On Wed, 2010-09-29 at 12:00 +0200, Roberto Sassu wrote:
> > > When a new encrypted key is created through the keyctl utility, the master
> > > key specified is not searched in the keyring and the operation is performed even 
> > > if it is missing.
> > 
> > Yes, and why is this a problem?  After creating a new key, the first
> > thing done should be to save it.  At that point, you'd find out the
> > master-key doesn't exist, requiring you to either load it or change the
> > master-key name using 'keyctl update'.
> > 
> 
> I think the master key verification is important at least for one reason:
> i suppose to have one encrypted key which depends on a trusted key unsealed
> during the boot process. 

Yes, this would be the normal scenario - decrypting the encrypted key
with a trusted key.

> If the former key is present in the keyring, this does not mean
> that the platform is in a good status (condition required for the unsealing),  
> since an attacker can generate another encryption key with the same name that 
> may be used by users to encrypt their personal data.

True, the existence of an encrypted key with the expected name does not
imply anything about the key.  However, using this 'fake' key will fail
to decrypt anything already encrypted with the real key. I'm not clear
how requiring the existence of the master-key prevents creating a 'fake'
key.

> The create check is probably wrong, what i mean is that key generation is an 
> administrative task and trusted and encrypted keys should be usable only after 
> decryption with the key they depend to.

I understand your concern, but checking the existence of the master-key
at creation doesn't imply that it will exist later, when needed to save
the new key.  So immediately after creating a new key, it's important to
save both the master-key and the encrypted key.

Mimi
