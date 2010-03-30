From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Tue, 30 Mar 2010 19:47:23 +0200
Message-ID: <ac3eb2511003301047v60bf37fdh141ffc6960c67903@mail.gmail.com>
References: <20100320010849.GA30654@gondor.apana.org.au> <20100320042103.GB5127@jenkins>
	<20100320042434.GA32294@gondor.apana.org.au> <20100319.222325.260105122.davem@davemloft.net>
	<20100320122959.GA1930@gondor.apana.org.au> <20100330165009.GP21087@jenkins.home.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, rusty@rustcorp.com.au
To: Brandon Philips <brandon@ifup.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45305 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0C3Rrk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Mar 2010 13:47:40 -0400
Received: by bwz1 with SMTP id 1so4584575bwz.21
        for <linux-crypto@vger.kernel.org>; Tue, 30 Mar 2010 10:47:38 -0700 (PDT)
In-Reply-To: <20100330165009.GP21087@jenkins.home.ifup.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 30, 2010 at 18:50, Brandon Philips <brandon@ifup.org> wrote:
> Side note: Intially I thought that modprobe was forking for each
> module dependency but that was incorrect after looking at the
> code. udev is forking off two modprobes almost at the same time for
> each bnx2x device alias when udevadm trigger is called during the boot
> sequence.

Right, that's the standard behavior, and applies to all usual systems.

> FWIW, I don't think this is a SUSE thing as our udev is pretty lightly
> patched.

Yes, there is no SUSE patch at all. All usual systems ship the same stuff here.

Kay
