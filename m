From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Thu, 30 Aug 2007 07:55:17 +0800
Message-ID: <E1IQXNV-0003Ed-00@gondolin.me.apana.org.au>
References: <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
Cc: silencer@gmx.ch, linux-crypto@vger.kernel.org,
	jordan.crouse@amd.com
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2457 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755000AbXH2Xzw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 19:55:52 -0400
In-Reply-To: <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> 
> Actually it is. geode does not support keys != 128 bit. ESSIV uses as
> key the output of sha256 what is 256. Check dmesg please. If my theory
> is correct than you should see in dmesg or somewhere:
> "Failed to set key for ESSIV cipher"
> Is it?

Jordan, could you please confirm whether geode-aes supports
key sizes other than 128, i.e., 192 and 256?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
