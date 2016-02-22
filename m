From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto
 layer
Date: Mon, 22 Feb 2016 15:35:16 -0800
Message-ID: <56CB9B34.20902@intel.com>
References: <56CB68A2.50505@intel.com>
 <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
 <20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
 <1562.1456180090@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbcBVXjd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2016 18:39:33 -0500
In-Reply-To: <1562.1456180090@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/22/2016 02:28 PM, David Howells wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> 
>> I wonder if this should be merged with the crypto/rsa-pkcs1pad.c template
>> that we already have. Looks like the two do the same padding now.
>> Should we merge then and pass the hash param as a separate template param,
>> e.g the public_key would allocate "pkcs1pad(rsa, sha1)"?
> 
> Ummm...  Possibly.  Is that how it's used?
> 
> 	warthog>git grep pkcs1pad -- Documentation
> 	warthog1>

Yes, no docs. Sorry.

> 
> Anyway, the problem I have with this is that I want to get that knowledge out
> of the asymmetric key in-software public key subtype.  It knows "rsa", "dsa",
> "ecdsa", ... because that's all the OIDs tell it.

Rigth, for now the public_key would need to build the full algorithm string as
follows:

vsprintf(name, "pkcs1pad(%s, %s)", pkey_algo_name[sig->pkey_algo],
         hash_algo_name[sig->pkey_hash_algo]);

Do you plan to add more padding schemes later? 

> 
> I guess if I have to, I can stoop to converting "rsa" to "pkcs1pad(rsa, sha1)".
> 
> Can you do me a really quick merge?  -rc5 is already out, and I want to get it
> to James pronto - plus I have things that are pending on this change being
> made.

Yes, I can start woring on a subsequent patch based on your changes in
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-rsa
Is that ok with you?

> 
> Oh - and how does the padding template find the algorithm DER encoding string
> to use?  I have wondered whether it should be stored in with the hash
> algorithm, but it probably makes more sense to keep it with the rsa module.

We can put everything into the crypto/rsa-pkcs1pad.c
This is where all the padding logic should be, I think.
Thanks,
-- 
TS
