From: "Mcloughlin, Conor" <conor.mcloughlin@intel.com>
Subject: RE: [PATCH] Enable slice hang handling for C3X and C6X devices.
Date: Tue, 5 Jul 2016 11:04:34 +0000
Message-ID: <CE2E46B8F68C4948A08D2E78E3D946C11C4DC7B2@IRSMSX104.ger.corp.intel.com>
References: <1467709627-26551-1-git-send-email-conor.mcloughlin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14789 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbcGELEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 07:04:37 -0400
In-Reply-To: <1467709627-26551-1-git-send-email-conor.mcloughlin@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Mcloughlin, Conor
> Sent: Tuesday, July 5, 2016 10:07 AM
> To: linux-crypto@vger.kernel.org
> Cc: Mcloughlin, Conor <conor.mcloughlin@intel.com>
> Subject: [PATCH] Enable slice hang handling for C3X and C6X devices.
> 
> If the QAT device fails to respond to a command, a watchdog
> timer triggers an interrupt. This event is reported and the
> the interrupt cleared. A separate watchdog register is used
> for sym and asym crypto.
> 
> Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>

Please ignore this patch. It depends on other functionality that has not yet been submitted.


--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.
