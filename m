From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: RSA decryption output length
Date: Tue, 9 Feb 2016 16:48:22 +0000
Message-ID: <VI1PR04MB1311D0E9CC8002BEB28676C6B8D60@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <VI1PR04MB1311DE5E1DE2E2B818797450B8D20@VI1PR04MB1311.eurprd04.prod.outlook.com>
 <56B4DFD5.6010600@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0055.outbound.protection.outlook.com ([157.56.112.55]:26992
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751197AbcBIQsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 11:48:25 -0500
In-Reply-To: <56B4DFD5.6010600@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks Tadeusz,

The leading zeros are discarded in the process of conversion the byte array data to a big integer. When talking about numbers, the leading zeros are not meaningful.

ta

-----Original Message-----
From: Tadeusz Struk [mailto:tadeusz.struk@intel.com] 
Sent: Friday, February 05, 2016 7:46 PM
To: Tudor-Dan Ambarus; linux-crypto@vger.kernel.org
Subject: Re: RSA decryption output length

Hi Tudor-Dan,
On 02/05/2016 07:25 AM, Tudor-Dan Ambarus wrote:
> I see that in qat, if the RSA decryption output data has the first octets of value zero, you skip them, actualize the dst_len and memmove the decrypted data to the initial pointer (see [1]). Why do you do this? Why can't you keep the decryption output data of key length?

This is because the SW RSA implementation works the same way.
MPI lib also discards the leading zeros.
The two implementations have to produce the same output for a given input.
Thanks,

-- 
TS
