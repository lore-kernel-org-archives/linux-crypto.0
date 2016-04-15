From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - fix dst len
Date: Fri, 15 Apr 2016 22:34:13 +0800
Message-ID: <20160415143413.GD733@gondor.apana.org.au>
References: <1459978952-18238-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459978952-18238-1-git-send-email-tadeusz.struk@intel.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 06, 2016 at 02:42:32PM -0700, Tadeusz Struk wrote:
> The output buffer length has to be at least as big as the key_size.
> It is then updated to the actual output size by the implementation.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
