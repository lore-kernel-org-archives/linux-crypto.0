From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: Re: [PATCH 0/2] Automatically load the vmx_crypto module if
 supported
Date: Wed, 13 Jul 2016 15:54:59 +1000
Message-ID: <1468389299.4705.26.camel@au1.ibm.com>
References: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: benh@kernel.crashing.org, paulus@samba.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: mpe@ellerman.id.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53164 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbcGMFzW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jul 2016 01:55:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6D5rjoh095434
	for <linux-crypto@vger.kernel.org>; Wed, 13 Jul 2016 01:55:17 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2452xreeg3-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 13 Jul 2016 01:55:16 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <alastair@au1.ibm.com>;
	Wed, 13 Jul 2016 15:55:14 +1000
In-Reply-To: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2016-07-13 at 15:47 +1000, alastair@au1.ibm.com wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> > This series allows the vmx_crypto module to be detected and
> automatically
> loaded via UDEV if the CPU supports the vector crypto feature.
> > Alastair D'Silva (2):
> =C2=A0 powerpc: Add module autoloading based on CPU features
> =C2=A0 crypto: vmx - Convert to CPU feature based module autoloading
> > =C2=A0arch/powerpc/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A01 +
> =C2=A0arch/powerpc/include/asm/cpufeature.h | 70
> +++++++++++++++++++++++++++++++++++
> =C2=A0drivers/crypto/vmx/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0drivers/crypto/vmx/vmx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A06 +--
> =C2=A04 files changed, 74 insertions(+), 5 deletions(-)
> =C2=A0create mode 100644 arch/powerpc/include/asm/cpufeature.h

Please ignore the following:
=C2=A0 [PATCH 1/2] Allow drivers to be autoloaded.
=C2=A0 [PATCH 2/2] Automatically load the vmx_crypto module if supporte=
d.

-- Alastair D'Silva
Open Source Developer
Linux Technology Centre, IBM Australia
mob: 0423 762 819
