Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3262A1
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 20:32:20 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rAN6V-006wuV-Od; Tue, 05 Dec 2023 12:32:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 Dec 2023 12:32:25 +0800
Date: Tue, 5 Dec 2023 12:32:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: liulongfang <liulongfang@huawei.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 10/19] crypto: hisilicon/sec2 - Remove cfb and ofb
Message-ID: <ZW6n2RBUslpeJTrS@gondor.apana.org.au>
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
 <E1r8g9A-005ILj-Sb@formenos.hmeau.com>
 <2f75977b-1383-908d-bf32-5084ef260c53@huawei.com>
 <382efecd-5b2c-a328-3ef3-16d4b2b66590@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <382efecd-5b2c-a328-3ef3-16d4b2b66590@huawei.com>

On Mon, Dec 04, 2023 at 10:14:21AM +0800, liulongfang wrote:
.
> Hi Herbert:
> After reviewing the code, I found that there is still a place where the code
> needs to be modified.
> A register value indicating OFB and CFB modes needs to be updated:

Thanks.  I've added this to the patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
