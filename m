From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 12:25:58 -0700
Message-ID: <54358FC6.8060500@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbaJHT1y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 15:27:54 -0400
In-Reply-To: <54358A06.2080605@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2014 12:01 PM, Prarit Bhargava wrote:
> No that isn't correct.  dev_to_node() will return the node the device is
> connected to.

include/linux/device.h:

static inline int dev_to_node(struct device *dev)
{
  return dev->numa_node;
}

struct device {
.....
  int numa_node; /* NUMA node this device is close to */
...
};

In case when there are two nodes and only node 0 has memory,
dev->numa_node will be 0 even though the device will be connected to the
pci root port of node 1.
