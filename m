From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Question about Talitos Linux driver for MPC885
Date: Tue, 25 Sep 2012 10:45:17 +0200
Message-ID: <50616F1D.108@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: kim.phillips@freescale.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:38720 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2IYJah (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Sep 2012 05:30:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Kim,

I'm trying to use the Talitos crypto driver with the MPC885 
microcontroller. For the time being, it doesn't work.
The kernel startup blocks at the test of the DES function.

I have added the following definition in the DTS file:

         crypto@20000 {
             compatible = "fsl,sec2.0";
             reg = <0x20000 0x8000>;
             interrupts = <1 1>;
             interrupt-parent = <&PIC>;
             fsl,num-channels = <1>;
             fsl,channel-fifo-len = <24>;
             fsl,exec-units-mask = <0x4c>;
             fsl,descriptor-types-mask = <0x301f>;
         };

I have this defined in the config file

CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_FSL_CAAM is not set
CONFIG_CRYPTO_DEV_TALITOS=y


Is there anything wrong in what I did ? Or is there something else I 
should do ?

Regards
Christophe
