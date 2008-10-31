From: "Nipper Lee" <Lee.Nipper@freescale.com>
Subject: RE: Enabling Talitos kills all IPsec traffic
Date: Thu, 30 Oct 2008 17:05:36 -0700
Message-ID: <E036452DB507994DAF931ADC4A56AE2002BA6E1B@az33exm25.fsl.freescale.net>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com> <20081028190257.a0d5a6d8.kim.phillips@freescale.com> <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com> <20081029194001.1264cf20.kim.phillips@freescale.com> <61362e760810300958p70d96138xbadd42a53a6f4abc@mail.gmail.com> <61362e760810301606y3ca2e6ffr669e020e27b9fa71@mail.gmail.com> <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Barry G" <mr.scada@gmail.com>,
	"Phillips Kim-R1AAHA" <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:39869 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbYJaAGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2008 20:06:01 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.12.11/az33egw02) with ESMTP id m9V05w2Q005420
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 17:05:59 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id m9V05v3D005388
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2008 19:05:57 -0500 (CDT)
Content-class: urn:content-classes:message
In-Reply-To: <E036452DB507994DAF931ADC4A56AE2002BA6DFC@az33exm25.fsl.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> From: linux-crypto-owner@vger.kernel.org 
> [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of 
> Nipper Lee-B04937
> Sent: Thursday, October 30, 2008 6:11 PM
> 
> I have a simple strongswan example which works with talitos aes256,
> but it uses ikev1 (pluto). 
> 

Barry,

In case it provides any help, see below for ipsec.conf & ipsec.secrets
for a tiny strongswan example which works with talitos doing the
encryption/decryption.
I'm using kernel 2.6.27 on 8349E MDS, and strongswan version 4.2.8.

Lee

################################################## 
# /etc/ipsec.conf:
version	2.0

config setup
	 plutodebug=dns
	 interfaces="ipsec0=eth1"

conn hometooffice
  left=200.200.200.10
  leftid="@home"
  leftsubnet=192.168.1.0/24
  right=200.200.200.20
  rightid="@office"
  rightsubnet=192.168.2.0/24
  keyexchange=ikev1
  pfs=yes
  authby=secret
  auto=add
  esp=aes256-sha2_256

conn officetohome
  left=200.200.200.20
  leftid="@office"
  leftsubnet=192.168.2.0/24
  right=200.200.200.10
  rightid="@home"
  rightsubnet=192.168.1.0/24
  keyexchange=ikev1
  pfs=yes
  authby=secret
  auto=add
  esp=aes256-sha2_256
 

################################################## 
# /etc/ipsec.secrets:
# Format for psk: @self @peer PSK "secret"
@home  @office: PSK "secret1"
