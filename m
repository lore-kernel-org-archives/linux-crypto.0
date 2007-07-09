From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: BigNum support in Kernel?
Date: Tue, 10 Jul 2007 01:02:03 +0530
Message-ID: <a781481a0707091232s2d4db56bqe144287bc3b0bf49@mail.gmail.com>
References: <f8b2ccd40707091155g23bea086o194203f0df6df3e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Gautam Singaraju" <gautam.singaraju@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:25118 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXGITcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2007 15:32:04 -0400
Received: by nz-out-0506.google.com with SMTP id s18so775684nze
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jul 2007 12:32:03 -0700 (PDT)
In-Reply-To: <f8b2ccd40707091155g23bea086o194203f0df6df3e8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gautam,

[ trimmed Cc: list ]

On 7/10/07, Gautam Singaraju <gautam.singaraju@gmail.com> wrote:
> All,
>
> I am planning to work on some experimental crypto support in kernel
> level. For the development, I need to use BigNum library. I wanted to
> load a minimal BigNum library into memory for high performance. Any
> suggestions on what library would be the best?

Red Hat / Fedora / Debian / most other distributions have been
maintaining a kernel port of the GNU MPI math library for several
years now. It's not difficult to write your own either, of course.

Satyam
