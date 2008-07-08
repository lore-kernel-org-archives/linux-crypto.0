From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Freescale SEC driver with cryptoloop on MPC8567e
Date: Tue, 8 Jul 2008 15:28:47 -0500
Message-ID: <20080708152847.6a248104.kim.phillips@freescale.com>
References: <5c9cd53b0807081103y583d0013ic0d22fb46490be2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: "mike zheng" <mail4mz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:33652 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbYGHU3K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2008 16:29:10 -0400
In-Reply-To: <5c9cd53b0807081103y583d0013ic0d22fb46490be2b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 8 Jul 2008 14:03:28 -0400
"mike zheng" <mail4mz@gmail.com> wrote:

> Hello,
> 
> Any one know how can I integrate the Freescale's SEC driver with
> cryptoloop in Kernel2.4 on MPC8567e? Or which version of kernel shall
> I take if it is already there?

Take Herbert's cryptodev-2.6 tree and add support in the talitos driver
for the ablkcipher algorithm you're using.

Kim
