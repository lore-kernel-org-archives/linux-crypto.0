From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: atmel-sha: fix algorihtm registration
Date: Mon, 1 Feb 2016 16:22:01 +0800
Message-ID: <20160201082201.GE5818@gondor.apana.org.au>
References: <da09591cf85a1882817bbf7cb527bb228d3f8f87.1454082992.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nicolas.ferre@atmel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da09591cf85a1882817bbf7cb527bb228d3f8f87.1454082992.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 29, 2016 at 05:04:02PM +0100, Cyrille Pitchen wrote:
> This patch implements the missing .import() and .export() mandatory
> hooks for asynchronous hash algorithms. It also sets the relevant, non
> zero, value for the .statesize field when declaring the supported SHA
> algorithms. Indeed a zero value of .statesize prevents the algorithm from
> being registered.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
