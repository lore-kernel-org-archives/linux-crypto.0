From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 1/2] lib/scatterlist: Add sg_len helper
Date: Tue, 22 Sep 2015 07:28:40 -0700
Message-ID: <56016598.1070204@intel.com>
References: <20150921234408.23782.52608.stgit@tstruk-mobl1>
 <20150921234414.23782.63763.stgit@tstruk-mobl1>
 <1629054.0zdmkST5GO@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbbIVOad (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 10:30:33 -0400
In-Reply-To: <1629054.0zdmkST5GO@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 09/21/2015 10:52 PM, Stephan Mueller wrote:
>> /**
>> >+  * sg_len - return total size of bytes in the scatterlist
>> >+  * @sg:         The scatterlist
>> >+  *
>> >+  * Description:
>> >+  * Allows to know how the total size of bytes in sg, taking into account
>> >+  * chaining as well
>> >+  **/
>> >+int sg_len(struct scatterlist *sg)
>> >+{
>> >+	int len;
> Is there a reason why unsigned int is not used? Note, this applies to the 
> users of that function too.
> 
Ok, I'll change it to unsigned int.
Thanks
