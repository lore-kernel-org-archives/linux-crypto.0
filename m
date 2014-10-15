From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and
 numa
Date: Wed, 15 Oct 2014 09:24:30 -0700
Message-ID: <543E9FBE.8010705@intel.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <543E4DFF.9000101@redhat.com> <543E59B9.6060804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>,
	Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaJOQ0s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 12:26:48 -0400
In-Reply-To: <543E59B9.6060804@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/15/2014 04:25 AM, Prarit Bhargava wrote:
>> I just gave a quick run of these patches and they seem to fix the NUMA issue and
>> > the 0 length warnings.
>> > 
>> > Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>
> Thanks Nik :)
> 
> Reviewed-by: Prarit Bhargava <prarit@redhat.com>

Thank you Nik and Prarit
