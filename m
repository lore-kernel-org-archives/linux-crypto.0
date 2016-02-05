From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: RSA decryption output length
Date: Fri, 5 Feb 2016 09:45:57 -0800
Message-ID: <56B4DFD5.6010600@intel.com>
References: <VI1PR04MB1311DE5E1DE2E2B818797450B8D20@VI1PR04MB1311.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbcBERuB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Feb 2016 12:50:01 -0500
In-Reply-To: <VI1PR04MB1311DE5E1DE2E2B818797450B8D20@VI1PR04MB1311.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor-Dan,
On 02/05/2016 07:25 AM, Tudor-Dan Ambarus wrote:
> I see that in qat, if the RSA decryption output data has the first octets of value zero, you skip them, actualize the dst_len and memmove the decrypted data to the initial pointer (see [1]). Why do you do this? Why can't you keep the decryption output data of key length?

This is because the SW RSA implementation works the same way.
MPI lib also discards the leading zeros.
The two implementations have to produce the same output for a given input.
Thanks,

-- 
TS
