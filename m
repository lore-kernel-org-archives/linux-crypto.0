From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/1] SHA1 transform: x86_64 AVX2 optimization -v3
Date: Wed, 19 Mar 2014 20:40:12 +0100
Message-ID: <201403192040.12421.marex@denx.de>
References: <1395187947.2367.9.camel@pegasus.jf.intel.com> <1395190002.2367.17.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51741 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaCSTkS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 15:40:18 -0400
In-Reply-To: <1395190002.2367.17.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, March 19, 2014 at 01:46:42 AM, chandramouli narayanan wrote:
> Sorry, there seems to be a problem with the patch. Let me retest from
> the list again and repost.

Before you do that, please ...
1) Please do not top-post in replies
2) Fix the changelog (see below)

> On Tue, 2014-03-18 at 17:12 -0700, chandramouli narayanan wrote:
> > This git patch adds x86_64 AVX2 optimization of SHA1 transform
> > to crypto support. The patch has been tested with 3.14.0-rc1
> > kernel.
> > 
> > On a Haswell desktop, with turbo disabled and all cpus running
> > at maximum frequency, tcrypt shows AVX2 performance improvement
> > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > AVX implementation.
> > 
> > This patch adds sha1_avx2_transform(), the glue, build and
> > configuration changes needed for AVX2 optimization of SHA1 transform to
> > crypto support.
> > 
> > Changes noted from the initial version of this patch are based on the
> > feedback from the community:
> > a) check for BMI2 in addition to AVX2 support since
> > __sha1_transform_avx2() uses rorx
> > b) Since the module build has dependency on 64bit, it is
> > redundant to check it in the code here.
> > c) coding style cleanup
> > d) simplification of the assembly code where macros are repetitively
> > used.

All this changelog for the patch goes under the diffstat ... oh, but where did 
the diffstat go anyway ? I think you are producing the patch in some weird way.

I suggest you produce the patch like so:

$ git format-patch HEAD~1 -o /tmp/mypatches-to-submit/

Then to submit the email with a patch, do:

$ git send-email --annotate --to=linux-crypto@vger.kernel.org \
    --cc="cc@example.com" --cc="another_guy@example.com" \
    /tmp/mypatches-to-submit/*.patch

Also, you can avoid adding these --cc="..." options each and every time by 
simply adding "Cc: Per Son <cc@example.com>" tag to your patch's description 
just below the 'Signed-off-by:' tag.

Moreover, when sending a V3 of a patch, adjust the subject as such:
[PATCH V3] SHA1 transform: x86_64 AVX2 optimization
or if it's a patch which is part of series:
[PATCH 1/n V3] SHA1 transform: x86_64 AVX2 optimization

Hope that helps :)

[...]
