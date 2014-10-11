From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Sat, 11 Oct 2014 10:05:40 -0700
Message-ID: <54396364.1020703@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com> <54367016.3070709@redhat.com> <5436B459.4090503@intel.com> <5436C6BA.2020404@redhat.com> <5436E818.5030809@intel.com> <54370163.6040305@redhat.com> <5437165E.6030008@intel.com> <5437C1C9.7050505@redhat.com> <5437DE2F.5080900@intel.com> <54385A88.5040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaJKRHk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Oct 2014 13:07:40 -0400
In-Reply-To: <54385A88.5040901@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/10/2014 03:15 PM, Prarit Bhargava wrote:
> In short, that calcuation is wrong.  Don't use it; stick with the widely
> accepted and used dev_to_node of the pci_dev.  It is used in other cases IIRC to
> determine the numa location of the device.  It shouldn't be any different for
> this driver.
As a matter of fact this is what we are doing now. Effectively
dev_to_node() is used for all numa allocations.
The only reason it was done this way was to ensure the best performance.
We are competing with very fast on core encryption here and the only way
we can beat that is to make sure the dma transactions will not have to
go over the QPI link to the remote numa node. If it will then the
performance will drop significantly and in this case we don't want to
bring the device up.
I agree that this is not the most elegant way to figure out the numa
locality for a device, but it worked for us so far.
Anyway I think I know how to get done this using ACPI. Will send v2 on
Monday.
T.
