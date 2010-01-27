From: Milan Broz <mbroz@redhat.com>
Subject: Re: how the key is generated?
Date: Wed, 27 Jan 2010 09:21:01 +0100
Message-ID: <4B5FF76D.3080406@redhat.com>
References: <f3566d61001260041s13286706ra5c032ea2b4ce1d6@mail.gmail.com>	 <4B5EAEB0.9040205@redhat.com> <f3566d61001261921v2a7f319bgddb3a3bc971eea10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Bai Shuwei <baishuwei@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab0A0IVF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2010 03:21:05 -0500
In-Reply-To: <f3566d61001261921v2a7f319bgddb3a3bc971eea10@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/27/2010 04:21 AM, Bai Shuwei wrote:
> On Tue, Jan 26, 2010 at 4:58 PM, Milan Broz <mbroz@redhat.com> wrote:
> I use "dmsetup table --showkeys" get the bellow information.
> 
> disk$ sudo dmsetup table --showkeys /dev/mapper/dsi0
> 0 2040 crypt aes-xts-plain
> 3131313131313131313131313131313131313131313131313131313131313131 0 7:0
> 2056
> 
> If i forget the passphase, can i use the above information/key to
> recovery my disk?

yes, if you know mapping table (iow: key, cipher and mode,
IV and device offset), you can map this device directly using dmsetup.
(try dmsetup create dsi0 --table "0 2040 crypt .... 7:0 2056")

Anyway, you can better backup LUKS header and use some other passphrase,
there is also volume_key project, which implements key escrow (for cryptsetup too).

Milan
