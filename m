From: Casey Leedom <leedom@chelsio.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Tue, 3 Oct 2017 22:22:31 +0000
Message-ID: <MWHPR12MB1600E4FC91BC6D99017D3FCDC8720@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <fe25071a-18bf-e468-01e7-36515f2110e2@chelsio.com>
 <MWHPR12MB160034E91A834504FE85C07BC87E0@MWHPR12MB1600.namprd12.prod.outlook.com>,<e2c92d3a-3d5d-a0eb-7d5f-a9453e48cfd5@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Atul Gupta <atul.gupta@chelsio.com>
To: "Harsh  Jain" <Harsh@chelsio.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0115.outbound.protection.outlook.com ([104.47.36.115]:19252
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751135AbdJCWWh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 18:22:37 -0400
In-Reply-To: <e2c92d3a-3d5d-a0eb-7d5f-a9453e48cfd5@chelsio.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

| From: Harsh Jain <Harsh@chelsio.com>
| Sent: Tuesday, October 3, 2017 5:22 AM
|
| Hi Robin/Ashok,
|
| Find attached trace of DMA write error. I had a look on trace but didn't
| find anything suspicious.
|
| Let me know if you need more trace.

As a reminder, Harsh and Atul will be waking up in a few hours, so if there
are additional tests for which you'd like them to gather data, it would be
good to ask now so it's available to them to work on while we're all off
asleep ...

Casey
