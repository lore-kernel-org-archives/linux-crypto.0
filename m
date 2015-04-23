From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: crypto: fips - Move fips_enabled sysctl into fips.c
Date: Thu, 23 Apr 2015 09:36:46 +0200
Message-ID: <5538A10E.1090307@iogearbox.net>
References: <20150422050222.GA7414@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:48652 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbDWHgt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 03:36:49 -0400
In-Reply-To: <20150422050222.GA7414@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/22/2015 07:02 AM, Herbert Xu wrote:
> There is currently a large ifdef FIPS code section in proc.c.
> Ostensibly it's there because the fips_enabled sysctl sits under
> /proc/sys/crypto.  However, no other crypto sysctls exist.
>
> In fact, the whole ethos of the crypto API is against such user
> interfaces so this patch moves all the FIPS sysctl code over to
> fips.c.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
...
>
>   int fips_enabled;
>   EXPORT_SYMBOL_GPL(fips_enabled);

While you're at it, this should also be marked as __read_mostly.

Thanks,
Daniel
