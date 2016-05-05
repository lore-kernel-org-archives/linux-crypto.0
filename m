From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: Add a flag allowing the self-tests to be
 disabled at runtime.
Date: Thu, 5 May 2016 14:46:00 +0800
Message-ID: <20160505064600.GA4325@gondor.apana.org.au>
References: <1462266017-28022-1-git-send-email-rjones@redhat.com>
 <1462266017-28022-2-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, davem@davemloft.net,
	sm@eperm.de
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462266017-28022-2-git-send-email-rjones@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 03, 2016 at 10:00:17AM +0100, Richard W.M. Jones wrote:
> Running self-tests for a short-lived KVM VM takes 28ms on my laptop.
> This commit adds a flag 'cryptomgr.notests' which allows them to be
> disabled.
> 
> However if fips=1 as well, we ignore this flag as FIPS mode mandates
> that the self-tests are run.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
