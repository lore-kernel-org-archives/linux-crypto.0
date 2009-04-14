From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: add self-tests for rfc4309(ccm(aes))
Date: Tue, 14 Apr 2009 07:13:25 -0400
Message-ID: <20090414111325.GA14305@hmsreliant.think-freely.org>
References: <200904091434.59639.jarod@redhat.com> <20090410023108.GA7933@localhost.localdomain> <200904131703.50196.jarod@redhat.com> <200904131911.01596.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert.xu@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48152 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZDNLNf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Apr 2009 07:13:35 -0400
Content-Disposition: inline
In-Reply-To: <200904131911.01596.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 13, 2009 at 07:11:00PM -0400, Jarod Wilson wrote:
> One more time, with feeling. Investigated using test vectors from rfc3610, but
> they all use a 13-byte nonce, we only support 11-byte, so I'm sticking with
> using the samples from a fips cavs example file I have on hand.
> 
> I swear I tested the first version of the patch before submitting last time,
> but upon further testing, don't know how it actually managed to run
> correctly w/o some of the additional changes in this version.
> 
> This version contains the same vectors, but some of them had incorrect klen's
> in them last time. Additionally, null input and associated data should be
> handled more appropriately, as well as the expected decryption verification
> failure vectors.
> 
> This version of the patch has been tested on both 2.6.30-rc1-git5 +
> cryptodev-2.6 and a Red Hat Enterprise Linux 5.x kernel, with some
> extra debugging spew added to verify it really *is* working.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
