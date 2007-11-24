From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/3] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Sat, 24 Nov 2007 19:23:06 +0800
Message-ID: <fd3e431c0711240323v294cad50sfcb4f97f9778f91@mail.gmail.com>
References: <fd3e431c0711211317rcec242t88fb44fba3def1ae@mail.gmail.com>
	 <fd3e431c0711211339x1f77a11cs7c6bed8501561042@mail.gmail.com>
	 <20071123115944.GB18862@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linux Crypto" <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:52543 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbXKXL3H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Nov 2007 06:29:07 -0500
Received: by wx-out-0506.google.com with SMTP id h31so112702wxd
        for <linux-crypto@vger.kernel.org>; Sat, 24 Nov 2007 03:29:06 -0800 (PST)
In-Reply-To: <20071123115944.GB18862@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Nov 23, 2007 7:59 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Could you please reformat this so that it's more in-line with
> what's already in arch/x86/crypto? In particular, indentation
> for the code would be nice :)

I did not reformat the code because I wanted to use Bernstein's code
verbatim without change. This is to allow people who have validated
his code previously to use it without validation again. But I guess
there is no harm tidying it up too if it is just a matter of
indentation. I suppose I should retain his comments as well as it
helps in reading the assembly. Will resubmit when I am done.

Swee Heng
