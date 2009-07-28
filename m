From: Nico Erfurth <ne@erfurth.eu>
Subject: Padlock with VIA Nano still crashing
Date: Tue, 28 Jul 2009 10:26:54 +0200
Message-ID: <4A6EB64E.3040209@erfurth.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.erfurth.eu ([89.107.64.155]:50946 "EHLO mail.erfurth.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZG1Iw4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2009 04:52:56 -0400
Received: from port-83-236-8-194.dynamic.qsc.de ([83.236.8.194] helo=[192.168.178.35])
	by mail.erfurth.eu with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <ne@erfurth.eu>)
	id 1MVi1P-0008Ew-9q
	for linux-crypto@vger.kernel.org; Tue, 28 Jul 2009 10:26:59 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I've tried to setup a fileserver with a Via Nano board (Jetway 
NF77-N1G6) to use it's Padlock encryption engine. All works fine with 
the software encryption, but when I try to use the Padlock driver I get 
sporadic crashes while reading and writing on my encrypted device.

I can't provide the crashdump right now, because the machine itself is 
not useable after the crash anymore. Whatever I try to do after the 
kernel panic just results in another panic.

But I've compared the message with the sourcecode and it seems to point 
to the "repz xcrypt-ecb" command used by aes_encrypt.

I've tried the latest cryptodev-2.6 and linux-2.6 (2.6.31-rc4) same 
problem with both versions. (Which include fixes for the Via Nano)

Does anybody have an idea how I could get the crashdump so I can send it 
to the list? If there is no other way I'll write it down next time.

Regards,
Nico
