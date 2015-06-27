From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] QAT: Fix uninitialized variable in qat driver
Date: Sat, 27 Jun 2015 06:50:05 -0700
Message-ID: <558EAA0D.5010607@intel.com>
References: <1435341408-21649-1-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	qat-linux <qat-linux@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62568 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbbF0NuU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Jun 2015 09:50:20 -0400
In-Reply-To: <1435341408-21649-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/26/2015 10:56 AM, Neil Horman wrote:
> Hit a warning when building QAT, indicating that sz_out might be uninitalized
> before use.  Looks like if you hit an error path and jump to err: you might find
> yourself trying to unmap an arbirarily long dma region.  Its safe on intel since
> intel defines the invalid dma address as zero, but other arches don't, and if
> qat makes its way to one of those, that can cause all sorts of corruption.

Hi Neil,
This is a false positive. The sz_out is always initialized before used because
the same condition i.e. if (sgl != sglout && buflout) is in the error path as
well as on the path where is is initialized.
This warning is printed by an old gcc version. If you'll use gcc 4.9 or later
it wont print it.

It didn't make it's way to linux-crypto for whatever reason so resending again.
regards,
T
