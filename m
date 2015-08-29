From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Sat, 29 Aug 2015 07:28:36 -0700
Message-ID: <55E1C194.1020608@intel.com>
References: <1440739738-19587-1-git-send-email-marcel@holtmann.org>
 <55E0EB89.6050800@intel.com>
 <C966DBDA-0161-4523-A705-43D96C7B8A04@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58620 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbH2OaQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Aug 2015 10:30:16 -0400
In-Reply-To: <C966DBDA-0161-4523-A705-43D96C7B8A04@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/28/2015 05:54 PM, Marcel Holtmann wrote:
>> If you want to do this you should also update the existing RSA test vectors, because
>> > they are failing after this patch is applied.
> the test vectors have been failing no matter what. The crypto/rsakey.asn1 is actually broken as I explained in previous emails. That the ASN.1 parser accepted the test vectors was a bug which has been fixed now.
> 

So that's a very nice bug, which makes things work nicely. I wish all the bugs were like this one ;) 
