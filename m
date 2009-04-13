From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] add self-tests for rfc4309(ccm(aes))
Date: Mon, 13 Apr 2009 17:03:48 -0400
Message-ID: <200904131703.50196.jarod@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <200904091516.57048.jarod@redhat.com> <20090410023108.GA7933@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert.xu@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZDMVEd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Apr 2009 17:04:33 -0400
In-Reply-To: <20090410023108.GA7933@localhost.localdomain>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 09 April 2009 22:31:08 Neil Horman wrote:
> On Thu, Apr 09, 2009 at 03:16:53PM -0400, Jarod Wilson wrote:
> > On Thursday 09 April 2009 14:52:04 Neil Horman wrote:
> > > On Thu, Apr 09, 2009 at 02:34:59PM -0400, Jarod Wilson wrote:
> > > > Patch is against current cryptodev-2.6 tree, successfully tested via
> > > > 'modprobe tcrypt type=45'. The number of test vectors might be a bit
> > > > excessive, but I tried to hit a wide range of combinations of varying
> > > > key sizes, associate data lengths, input lengths and pass/fail.
> > > > 
> > > > Signed-off-by: Jarod Wilson <jarod@redhat.com>

Ugh. I clearly missed *something* when testing, there's no way the patch
I sent actually fully passed. I have things working for real now though
locally, including a back-port to a certain 2.6.18-based kernel. :)

Updated patch or patches forthcoming... (probably tomorrow)

-- 
Jarod Wilson
jarod@redhat.com
