From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: LZO irreversible output?
Date: Wed, 3 Feb 2010 23:54:11 +0100
Message-ID: <201002032354.11284.rjw@sisk.pl>
References: <4B69ECE5.5060505@crca.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>,
	LKML <linux-kernel@vger.kernel.org>
To: Nigel Cunningham <ncunningham@crca.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:41218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab0BCWxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2010 17:53:32 -0500
In-Reply-To: <4B69ECE5.5060505@crca.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 03 February 2010, Nigel Cunningham wrote:
> Hi all.
> 
> (Not sent to LKML yesterday; no reply from linux-crypto yet, so resending).
> 
> A while back now, I stopped supplying the LZF compression algorithm with
> TuxOnIce and made LZO the default algorithm. Around the same time, we
> started getting occasional errors when reading images; decompression
> failures.
> 
> I've finally managed to find the time to properly look at this, and have
> managed to find a data page that LZO compresses, but seems to be unable
> to decompress back to the original contents. I'm wondering whether this
> is because I'm doing something wrong, or because there really is some
> data the LZO (or the kernel implementation) can't do reversible
> compression on.

Well, FWIW, we have never had any problems with the userland LZO in s2disk,
so if anything is wrong with LZO here, I guess it's the kernel code.

Rafael
