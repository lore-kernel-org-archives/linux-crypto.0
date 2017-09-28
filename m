From: Casey Leedom <leedom@chelsio.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 28 Sep 2017 16:17:59 +0000
Message-ID: <MWHPR12MB1600DA9DF9CF54221B752694C8790@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "Harsh Jain" <Harsh@chelsio.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
To: Robin Murphy <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0099.outbound.protection.outlook.com ([104.47.36.99]:45137
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751800AbdI1QSD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 12:18:03 -0400
In-Reply-To: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  Thanks Robin.  Harsh can certainly test your latest patch as soon as he's
back in the office tomorrow morning India time.  If your patch works and is
accepted, it sounds like the commit would be important enough to consider
backporting into various Long-Term Support releases and the affected
distributions.  What's the procedure for nominating a commit for LTS inclus=
ion?
=20
Casey
