From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Date: Mon, 29 Aug 2011 09:32:19 +0200
Message-ID: <4E5B4083.6050001@gnutls.org>
References: <4E5A3FCC.2030504@gnutls.org> <20110828.163554.2024158531156183815.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61338 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1H2Hc0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Aug 2011 03:32:26 -0400
In-Reply-To: <20110828.163554.2024158531156183815.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/28/2011 10:35 PM, David Miller wrote:

>> The benchmark idea was to test the speed of initialization, encryption
>> and deinitiation, as well as the encryption speed alone. These are the
>> most common use cases of the frameworks (i.e. how they would be used
>> by a cryptographic library).
> Be sure to use splice() with AF_ALG for maximum performance.
> For example, see the test program below.  You'll need to replace
> "8192" with whatever the page size is on your cpu.

As I understand with splice you can encrypt only page aligned data that 
span a multiple of pages. This is a very uncommon case. My benchmark 
targets the generic case, i.e., the way this interface will be used in 
crypto libraries like gnutls.

However, I'll update the comparison page to include the splice version 
as well.

regards,
Nikos
