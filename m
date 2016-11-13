From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam: do not register AES-XTS mode on LP units
Date: Sun, 13 Nov 2016 17:46:54 +0800
Message-ID: <20161113094654.GA7399@gondor.apana.org.au>
References: <1478541094-73173-1-git-send-email-sven.ebenfeld@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, horia.geanta@nxp.com, davem@davemloft.net,
        cata.vasile@nxp.com
To: Sven Ebenfeld <sven.ebenfeld@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478541094-73173-1-git-send-email-sven.ebenfeld@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 07, 2016 at 06:51:34PM +0100, Sven Ebenfeld wrote:
> When using AES-XTS on a Wandboard, we receive a Mode error:
> caam_jr 2102000.jr1: 20001311: CCB: desc idx 19: AES: Mode error.
> 
> According to the Security Reference Manual, the Low Power AES units
> of the i.MX6 do not support the XTS mode. Therefore we must not
> register XTS implementations in the Crypto API.
> 
> Signed-off-by: Sven Ebenfeld <sven.ebenfeld@gmail.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> 
> Cc: <stable@vger.kernel.org> # 4.4+
> Fixes: c6415a6016bf "crypto: caam - add support for acipher xts(aes)"

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
