From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] Fix prototype definitions of sha256_transform_asm,
 sha512_transform_asm
Date: Fri, 07 Jun 2013 09:47:54 -0700
Message-ID: <1370623674.27102.376.camel@schen9-DESK>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
	 <1364331519.27102.10.camel@schen9-DESK>
	 <1366403112.27102.112.camel@schen9-DESK>
	 <20130425130404.GA29292@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Jim Kukunas <james.t.kukunas@linux.intel.com>,
	Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130425130404.GA29292@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2013-04-25 at 21:04 +0800, Herbert Xu wrote:
> On Fri, Apr 19, 2013 at 01:25:12PM -0700, Tim Chen wrote:
> > Herbert,
> > 
> > This is a follow on patch to the optimized sha256 and sha512 patch series that's just
> > merged into the crypto-dev.  Let me know if you prefer me to respin the
> > patch series.
> > 
> > This patch corrects the prototype of sha256_transform_asm and
> > sha512_transform_asm function pointer declaration to static.  It also
> > fixes a typo in sha512_ssse3_final function that affects the computation
> > of upper 64 bits of the buffer size.
> 
> Thanks, I've folded this into the original patches in order to
> maintain bisectability.

Hi Herbert,

Wonder if you had a chance to merge this patch?  I think it is not in
the latest crypto-dev.

Thanks.

Tim
