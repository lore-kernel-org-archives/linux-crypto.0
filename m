From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: rsa - update accoring to akcipher API changes
Date: Wed, 9 Sep 2015 11:03:54 -0700
Message-ID: <55F0748A.4070609@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <20150909161532.2828.990.stgit@tstruk-mobl1>
 <1717447.bQZjD6cfWn@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:27969 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbbIISJ6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 14:09:58 -0400
In-Reply-To: <1717447.bQZjD6cfWn@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 09:35 AM, Stephan Mueller wrote:
>> +	if (sg_is_last(req->dst)) {
>> >+		ret = mpi_read_buffer(c, sg_virt(req->dst), dst_len,
>> >+				      &req->out_len, &sign);
>> >+	} else {
>> >+		void *ptr = kmalloc(dst_len, GFP_KERNEL);
>> >+
>> >+		if (!ptr)
>> >+			goto err_free_m;
>> >+
>> >+		ret = mpi_read_buffer(c, ptr, dst_len, &req->out_len, &sign);
>> >+		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
>> >+		kfree(ptr);
> Just a question: this code is present 4 times, can that be put into a separate 
> inline?
> 

I have put it like this because it is easier to read.
All 4 functions use different variable names according to the spec.
