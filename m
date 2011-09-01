From: Adam Tisovsky <tisovsky@gmail.com>
Subject: IPsec performance (in)dependent on ingress rate?
Date: Thu, 1 Sep 2011 16:24:31 +0200
Message-ID: <CAM7W65KL+9Dp258ESbz_FssmScTLMjkb-qO2PrK-1kLFQbvrEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43654 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1IAOYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 10:24:32 -0400
Received: by yie30 with SMTP id 30so1421812yie.19
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2011 07:24:31 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I=92m doing some benchmarks of IPsec performance on Cisco router and I
have experienced the situation described below. My question is whether
anybody has performed similar tests on Linux (StrongSWAN, OpenSWAN,=85)
or any other security gateway and can tell how did it behave.

When you are gradually increasing the rate of traffic to be secured
(using UDP as a transport protocol) you reach the maximum possible
throughput of the device. But when you continue increasing the rate of
ingress traffic beyond this point, the fowarding rate of device will
decrease. Example:

Max. throughput of device is 10 Mbps. If ingress traffic rate is 10
Mbps, then forwarding rate is 10 Mbps. But when ingress rate is 20
Mbps, you get forwarding rate only 5 Mbps.

I have experienced this on Cisco 1841 router with HW accelerator
DISABLED. After some investigation I foud out that more ingress
traffic utilizes main CPU more by interrupts. And interrupts go on the
expense of encryption process. Therefore the decrease of forwarding
rate. With HW accelerator enabled this situation on does not occur,
device forwards traffic at the maximum rate even if it=92s overloaded b=
y
the ingress tarffic.

I didin=92t find any information dealing with this, however I find it
quite interesting. I=92m also planning to do the tests on StrongSWAN an=
d
OpenSWAN, but it takes some time. So any information will be helpful
in advance.

Thank you
Adam
