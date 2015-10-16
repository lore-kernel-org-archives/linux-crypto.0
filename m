From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/8] crypto: hash: add zero length message hash for shax
 and md5
Date: Fri, 16 Oct 2015 13:26:08 +0200
Message-ID: <CAPDyKFosY=DsWcRjjio5WM+Cyy8DDnK5ixEt6bR3yimCLYR+OQ@mail.gmail.com>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
	<1444668826-6531-2-git-send-email-clabbe.montjoie@gmail.com>
	<20151014100802.GA15884@gondor.apana.org.au>
	<20151015094204.GA6305@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, thomas.lendacky@amd.com,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@the-dreams.de>,
	Kees Cook <keescook@chromium.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <montjoie.mailing@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37942 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbbJPL0K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 07:26:10 -0400
Received: by wicll6 with SMTP id ll6so5971841wic.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2015 04:26:08 -0700 (PDT)
In-Reply-To: <20151015094204.GA6305@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 October 2015 at 11:42, LABBE Corentin <montjoie.mailing@gmail.com> wrote:
> On Wed, Oct 14, 2015 at 06:08:02PM +0800, Herbert Xu wrote:
>> On Mon, Oct 12, 2015 at 06:53:39PM +0200, LABBE Corentin wrote:
>> > Some crypto drivers cannot process empty data message and return a
>> > precalculated hash for md5/sha1/sha224/sha256.
>> >
>> > This patch add thoses precalculated hash in include/crypto.
>> >
>> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> > ---
>> >  include/crypto/md5.h |  5 +++++
>> >  include/crypto/sha.h | 20 ++++++++++++++++++++
>> >  2 files changed, 25 insertions(+)
>> >
>> > diff --git a/include/crypto/md5.h b/include/crypto/md5.h
>> > index 146af82..6496ee0 100644
>> > --- a/include/crypto/md5.h
>> > +++ b/include/crypto/md5.h
>> > @@ -13,6 +13,11 @@
>> >  #define MD5_H2     0x98badcfeUL
>> >  #define MD5_H3     0x10325476UL
>> >
>> > +static const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
>> > +   0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
>> > +   0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
>> > +};
>> > +
>>
>> This potentially creates this structure in every file that includes
>> md5.h.  How about putting it into md5_generic and exporting it?
>>
>
> md5_generic does not exists, do you mean md5.c ?
> I have made some try with EXPORT_SYMBOL() but without success.
> Do you have any example of how to do that ?
>

In the header file:
extern const u8 md5_zero_message_hash[MD5_DIGEST_SIZE];

In the c-file:
const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
  0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
  0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
};
EXPORT_SYMBOL(md5_zero_message_hash);

Kind regards
Uffe
