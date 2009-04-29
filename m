From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips mode
Date: Wed, 29 Apr 2009 09:18:37 -0400
Message-ID: <200904290918.37623.jarod@redhat.com>
References: <200904282111.52074.jarod@redhat.com> <20090429131506.GA17254@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759870AbZD2NUj@vger.kernel.org>
In-Reply-To: <20090429131506.GA17254@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 29 April 2009 09:15:07 Herbert Xu wrote:
> On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> >
> > +notest:
> > +	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
> 
> Can notest ever get here with rc != 0?

Nope.

-- 
Jarod Wilson
jarod@redhat.com
