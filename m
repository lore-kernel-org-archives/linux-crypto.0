From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.3
Date: Tue, 13 Oct 2015 19:00:20 -0700
Message-ID: <CA+55aFyHSme2b7i9GW_SNtqkP6F7nYQBqgApPp6pZkp3bJP3bA@mail.gmail.com>
References: <20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150626102234.GA19393@gondor.apana.org.au>
	<20150908092502.GA8332@gondor.apana.org.au>
	<20150916103014.GA12315@gondor.apana.org.au>
	<20150926200133.GA19035@gondor.apana.org.au>
	<20151013121750.GA6408@gondor.apana.org.au>
	<CA+55aFz0ZdjpC_FpM6h=z_boK8HeKzgt_7Zm14TnrZYqx1SaUQ@mail.gmail.com>
	<20151014010304.GA12430@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38450 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbJNCAV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 22:00:21 -0400
In-Reply-To: <20151014010304.GA12430@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 6:03 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Oops, I should've waited for you to pull the previous one before
> pushing this one out.

You might try to start using signed tags for your pull requests. That
lessens this kind of issue, because now only will you write the tag
message and then your signing key pass phrase etc, the tag would
specify one very particular commit at the time of the tagging rather
than just have it be the default branch of your public repository.

                Linus
