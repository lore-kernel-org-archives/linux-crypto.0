From: Andre Bubel <news@andre-bubel.de>
Subject: Re: VIA Padlock: +30% XTS Performance by using ECB
Date: Sun, 16 May 2010 19:34:46 +0200
Message-ID: <4BF02CB6.5020707@andre-bubel.de>
References: <20100423154449.GA1138@darkside.12.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mario.Holbe@TU-Ilmenau.DE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49896 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab0EPRpI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 May 2010 13:45:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1ODhtg-0000GC-38
	for linux-crypto@vger.kernel.org; Sun, 16 May 2010 19:45:04 +0200
Received: from tor-84-23-64-114.anonymisierung.tor.anon1984.de ([84.23.64.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Sun, 16 May 2010 19:45:04 +0200
Received: from news by tor-84-23-64-114.anonymisierung.tor.anon1984.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Sun, 16 May 2010 19:45:04 +0200
In-Reply-To: <20100423154449.GA1138@darkside.12.kls.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 23.04.2010 17:44, Mario 'BitKoenig' Holbe wrote:
> Hello,

Hi Mario,

> the VIA Padlock engine comes without native XTS-AES support, thus
> compared to CBC-AES or ECB-AES XTS-AES performs quite bad on VIA CPUs
> because it calls the Padlock ACE for each single AESenc() operation.
> Using the Padlock's ECB-AES saves calls to the Padlock ACE and improv=
es
> the XTS-AES performance by 30% and more even in a naive proof-of-conc=
ept
> implementation.
> The idea comes from DiskCryptor which does this since v0.9.583.106.

The same problem exists with the mv_cesa driver. I really like to have =
a=20
solution for this as the performance of the system is mainly cripled by=
=20
the hard disk encryption.

> I have no idea where this should finally be implemented, since it slo=
ws
> down XTS on non-accelerated CPUs. Maybe a seperate xts-aes-padlock
> driver would make sense depending on how specific this is to VIA
> Padlock, i.e. how it performs on other non-XTS-capable accelerators.

I'm currently trying to get an understanding of the kernel crypto code,=
=20
but my impression is that instead of breaking support with the=20
synchronous API the better way would be to introduce asynchronous=20
ciphers (e.g. acipher) that can be used transparently by crypto_templat=
e=20
implementations to form an ablkcipher. In that way all crypto modes=20
would be supported and accelerated through hardware, even if it doesn't=
=20
provide an in-hardware implementation.

As I mentioned I'm new to the kernel API, so what is the opinion of=20
experienced developers on this? Is that in reach of the current API=20
architecture?

> Please CC: me in replies, I'm not a member of the list. Mail-F'up2
> should be set correctly.

Best regards,
Andr=E9 Bubel
