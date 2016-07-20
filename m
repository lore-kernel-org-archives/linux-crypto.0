From: Thomas Backlund <tmb@mageia.org>
Subject: Re: [PATCH] crypto: qat - make qat_asym_algs.o depend on asn1 headers
Date: Wed, 20 Jul 2016 18:37:07 +0300
Message-ID: <75bc3619-1d11-4759-257c-d2db4ba442ff@mageia.org>
References: <a53076f443d43d1153dcef0fb35126b5753b08c7.1467281942.git.jstancek@redhat.com>
 <20160701093008.GB13424@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"Salvatore Benedetto" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:22927 "EHLO
	mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbcGTPwU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jul 2016 11:52:20 -0400
In-Reply-To: <20160701093008.GB13424@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Den 01-07-2016 kl. 12:30, skrev Herbert Xu:
> On Thu, Jun 30, 2016 at 12:23:51PM +0200, Jan Stancek wrote:
>> Parallel build can sporadically fail because asn1 headers may
>> not be built yet by the time qat_asym_algs.o is compiled:
>>   drivers/crypto/qat/qat_common/qat_asym_algs.c:55:32: fatal error: qat_rsapubkey-asn1.h: No such file or directory
>>    #include "qat_rsapubkey-asn1.h"
>>
>> Signed-off-by: Jan Stancek <jstancek@redhat.com>
>> Cc: Tadeusz Struk <tadeusz.struk@intel.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>
> Jan, Salvatore just posted a patch to delete the qat ASN code
> altogether, so your patch won't be needed.
>
> Thanks,
>

Yeah, but that patch seem to be heading to 4.8 only , so qat build in 
upcoming 4.7 still breaks...

and pulling that fix only to 4.7 breaks too, so I guess more fixes
would be needed for proper backport then...

or are the qat fixes already queued somewhere for 4.7 final ?

--
Thomas
