From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] fix out of bound read in __test_aead()
Date: Sat, 6 Feb 2016 15:48:14 +0800
Message-ID: <20160206074813.GI22220@gondor.apana.org.au>
References: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
 <1454504292-17882-1-git-send-email-jmarchan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jerome Marchand <jmarchan@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454504292-17882-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 03, 2016 at 01:58:12PM +0100, Jerome Marchand wrote:
> __test_aead() reads MAX_IVLEN bytes from template[i].iv, but the
> actual length of the initialisation vector can be shorter.
> The length of the IV is already calculated earlier in the
> function. Let's just reuses that. Also the IV length is currently
> calculated several time for no reason. Let's fix that too.
> This fix an out-of-bound error detected by KASan.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
