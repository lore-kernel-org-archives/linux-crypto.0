From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Fri, 11 Jan 2013 09:26:24 -0800
Message-ID: <1357925184.17632.143.camel@schen9-DESK>
References: <CD14ACF3.1403F%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Alexander Boyko <alexander_boyko@xyratex.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab3AKR0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2013 12:26:23 -0500
In-Reply-To: <CD14ACF3.1403F%andreas.dilger@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2013-01-11 at 00:39 +0000, Dilger, Andreas wrote:

> 
> Maybe there is some confusion here?  The submitted patch is for CRC32,
> while you are referring to CRC32C (note trailing "C")?  Are they not
> different CRC functions, or can both CRCs be computed by the same code
> if there are different constants loaded?

Yeah, I missed the trailing C.  

Tim
