From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - Enforce valid numa configuration
Date: Tue, 14 Oct 2014 10:18:12 -0700
Message-ID: <543D5AD4.1090809@intel.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <20141014012432.742.24559.stgit@tstruk-mobl1> <543D00C3.9000208@redhat.com> <543D381B.9080609@intel.com> <543D441D.5090301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53569 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaJNRWB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Oct 2014 13:22:01 -0400
In-Reply-To: <543D441D.5090301@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/14/2014 08:41 AM, Prarit Bhargava wrote:
> Oh, that's a really good point.  But can you at least change the message to do a
> FW_BUG and dump the node information?  That would be useful for debugging.

But this not always will be a FW_BUG. If a user will not populate one of
the nodes with memory this will happen as well. I could see this to be
the main reason of this message to be printed. In this case
num_possible_nodes() will be e.g. 2 and dev_to_node(&pdev->dev) will be
-1 so I don't really know what will be a useful info to print so we
don't confuse the user.
T
