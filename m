Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB9D1712;
	Thu,  7 Dec 2023 20:06:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBS86-008If7-HF; Fri, 08 Dec 2023 12:06:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:06:32 +0800
Date: Fri, 8 Dec 2023 12:06:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-s390@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: s390/aes - Fix buffer overread in CTR mode
Message-ID: <ZXKWSF2WwaiwhbJN@gondor.apana.org.au>
References: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
 <ce50a198e3c59f30376cf54e52d5e749@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce50a198e3c59f30376cf54e52d5e749@linux.ibm.com>

On Tue, Nov 28, 2023 at 02:18:02PM +0100, Harald Freudenberger wrote:
>
> Here is a similar fix for the s390 paes ctr cipher. Compiles and is
> tested. You may merge this with your patch for the s390 aes cipher.

Thank you.  I had to apply this by hand so please check the result
which I've just pushed out to cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
