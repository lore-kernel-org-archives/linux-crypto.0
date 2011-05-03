From: Tzvi Chumash <tzvi@research.att.com>
Subject: Re: blowfish from openSSL to kernel cryptoAPI
Date: Tue, 03 May 2011 13:37:23 -0400
Message-ID: <ippek3$10l$1@dough.gmane.org>
References: <ipnbl5$ug4$1@dough.gmane.org>	 <4DC015AD.BA46DC3F@users.sourceforge.net>  <ipp84b$m6s$1@dough.gmane.org> <1304439565.2652.47.camel@ec>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55266 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab1ECRjb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2011 13:39:31 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1QHJZK-0004uA-7o
	for linux-crypto@vger.kernel.org; Tue, 03 May 2011 19:39:30 +0200
Received: from 135.207.174.202 ([135.207.174.202])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 19:39:30 +0200
Received: from tzvi by 135.207.174.202 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 19:39:30 +0200
In-Reply-To: <1304439565.2652.47.camel@ec>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/3/2011 12:19 PM, Emanuele Cesena wrote:
> It may be a stupid remark... anyway, OpenSSL uses key/iv "internally"
> and exposes to the user passphrase and salt. Did you check that you have
> not confused them?

I'm not using the command line openssl to produce the cipher.. the API 
says nothing about a salt or a passphrase:

  int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
                 ENGINE *impl, unsigned char *key, unsigned char *iv);

relevant parts of my openSSL code:
...
rc = EVP_EncryptInit_ex(&ctx, EVP_bf_cbc(), NULL, env_key, env_iv);
...
rc = EVP_EncryptUpdate(&ctx, out, &olen, in, ilen);
...
rc = EVP_EncryptFinal_ex(&ctx, out+olen, &olen);

where
EVP_CIPHER_CTX ctx;
unsigned char env_key[56];
unsigned char env_iv[8];
unsigned char *in, *out;
int rc, ilen, olen;


Thanks,

Tzvi
