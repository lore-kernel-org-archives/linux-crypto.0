From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: RSA signature verification
Date: Tue, 22 Mar 2011 10:57:55 +0200
Message-ID: <4D886493.5050204@nokia.com>
References: <4D875AF9.4060302@nokia.com> <20110321140653.GA14174@gondor.apana.org.au> <4D8848EC.6070306@nokia.com> <20110322073407.GA23028@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Morris <jmorris@namei.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:28038 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1CVI5r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 04:57:47 -0400
In-Reply-To: <20110322073407.GA23028@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Accepted by whom?
We extend functionality of Integrity subsystem in order to support
flashable images which can be verified with public keys...

- Dmitry

On 22/03/11 09:34, ext Herbert Xu wrote:
> On Tue, Mar 22, 2011 at 08:59:56AM +0200, Dmitry Kasatkin wrote:
>> As I have said in my email that it will be used by IMA/EVM subsystem.
>> See security/integrity subdirectory in Linux kernel...
> Has the use of software asymmetric crypto in the kernel been
> accepted for that purpose?
>
> Thanks,
