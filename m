From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch 0/3] crypto: padlock-aes: enable on VIA Nano
Date: Tue, 9 Jun 2009 12:29:10 -0400
Message-ID: <20090609122910.13972109@dhcp-100-2-144.bos.redhat.com>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34720 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZFIQaJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2009 12:30:09 -0400
In-Reply-To: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 9 Jun 2009 10:35:33 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> The VIA Nano has a bug that makes the padlock unit fetch extra data
> during encryption operations. Add workarounds for that, and enable
> the driver on x86_64.
> 
> 1/3 Fix ECB encryption mode
> 2/3 Fix CBC mode, clean up code
> 3/3 Enable building for 64-bit kernels

Forgot to mention, I have 64-bit working on a Samsung NC20 with LVM
encrypted disks using AES. The cryptomgr self-tests pass too. Before
the prefetch fixes it was oopsing near page boundaries when trying to
decrypt disk blocks.

