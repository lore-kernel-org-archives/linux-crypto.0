From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] PKCS#7: fix missing break on OID_sha224 case
Date: Tue, 5 Apr 2016 20:46:21 +0800
Message-ID: <20160405124621.GF13048@gondor.apana.org.au>
References: <1458316291-25705-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Peter Jones <pjones@redhat.com>, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458316291-25705-1-git-send-email-colin.king@canonical.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 18, 2016 at 03:51:31PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The OID_sha224 case is missing a break and it falls through
> to the -ENOPKG error default.  Since HASH_ALGO_SHA224 seems
> to be supported, this looks like an unintentional missing break.
> 
> Fixes: 07f081fb5057 ("PKCS#7: Add OIDs for sha224, sha284 and sha512 hash algos and use them")
> Cc: <stable@vger.kernel.org> # 4.2+
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
