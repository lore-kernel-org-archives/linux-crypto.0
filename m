From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.14 73/92] dm crypt: fix deadlock when async crypto
 algorithm returns -EBUSY
Date: Tue, 5 May 2015 09:53:34 +0800
Message-ID: <20150505015334.GB4993@gondor.apana.org.au>
References: <20150502190109.683061482@linuxfoundation.org>
 <20150502190117.069180534@linuxfoundation.org>
 <20150504213254.GA27445@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ben Collins <ben.c@servergy.com>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org
To: Rabin Vincent <rabin@rab.in>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150504213254.GA27445@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 04, 2015 at 11:32:54PM +0200, Rabin Vincent wrote:
> On Sat, May 02, 2015 at 09:03:28PM +0200, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Collins <ben.c@servergy.com>
> > 
> > commit 0618764cb25f6fa9fb31152995de42a8a0496475 upstream.
> 
> The commit in question was recently merged to mainline and is now being
> sent to various stable kernels.  But I think the patch is wrong and the
> real problem lies in the Freescale CAAM driver which is described as
> having being tested with.

I agree.  Please revert this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
