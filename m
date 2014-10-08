From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 15:01:26 -0400
Message-ID: <54358A06.2080605@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaJHTBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 15:01:39 -0400
In-Reply-To: <54358918.7030808@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/08/2014 02:57 PM, Tadeusz Struk wrote:
> On 10/08/2014 11:35 AM, Prarit Bhargava wrote:
>>> But then how do I know which node I'm physically connected to?
>> The pci_dev maps to the bus which maps to a numa node.  The pci_dev's numa value
>> is copied directly from the bus (or busses depending on how deep it is).
>>
>> I'd argue (strongly) that the pci_dev's numa ID better be correct o/w that is a
>> FW bug (and a bad one at that these days).
>>
>> dev_to_node() should return the correct value.
> 
> I'm not saying that the dev_to_node() returns incorrect value. It will
> always return the closest numa node for the given device.

No that isn't correct.  dev_to_node() will return the node the device is
connected to.

> What we want to enforce is that the closest numa node is the node that
> the device is physically connected to. In case if the closest numa node
> is the remote node we don't want to use this accelerator.
> 

P.
