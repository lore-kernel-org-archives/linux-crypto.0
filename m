Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420C3C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 13:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1129E2075E
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553175719;
	bh=YvvYNpMa58Wnr+qa8MS6ZhNIR+Ls8l3mwD5e9kz7BSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=V8wdlQeaVExmTBQPXPawercBmDko6Kweqnhkn4xZDEM2pElVbslMxXThEUXv4O7lO
	 m003LVBIOtL8WcjIecrYrhZS0DU6YVn+p4RIEDC3hHeDVKHzgIJPeEW4D28luEZVtj
	 Ba4zmDVC73hc4xWUzTDRu8g6M6gekCnp2Iqddz3U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfCUNlx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 09:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbfCUNlw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 09:41:52 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D32AA2075E;
        Thu, 21 Mar 2019 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553175712;
        bh=YvvYNpMa58Wnr+qa8MS6ZhNIR+Ls8l3mwD5e9kz7BSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHp8FBSTIhpooP7NQaCissGZiFo/NmrFrJl5M3cXU5Aikmw+zwuepzvrJXuvk9//e
         va/5702RUdrRWxb27EE1p46FKIhKwd8UO45rzw0dA25/ihn4LevReQfkdAaUUJ074w
         Zfq09LBkV6A5TIb/cJrHSXK6MQoRLaO/by6Dw8B0=
Date:   Thu, 21 Mar 2019 06:41:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lionel DEBIEVE <lionel.debieve@st.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [Bug] STM32 crc driver failed on selftest 1
Message-ID: <20190321134149.GB764@sol.localdomain>
References: <20190126210530.GB709@sol.localdomain>
 <39d55020-a4db-f5f8-e9b5-777690b85ed5@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39d55020-a4db-f5f8-e9b5-777690b85ed5@st.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 21, 2019 at 10:46:53AM +0000, Lionel DEBIEVE wrote:
> Hi All,
> 
> I'm looking further to debug an issue regarding CRC32 selftests. I'm 
> currently blocked on an issue about the second test vector implemented 
> on CRC32:
> static const struct hash_testvec crc32_tv_template[] = {
>      {
>          .plaintext = "abcdefg",
>          .psize = 7,
> 
>          .digest = "\xd8\xb5\x46\xac",
> 
>      },
> 
> I'm currently trying to understand the issue, but using others tools 
> (computer or Online CRC calculation), I'm not able to find any way to 
> get the expected output? This new vector was introduced for few version 
> but I'm wondering who was able to verify it.
> 
> Should it be written by byte? Word? Half word?
> 
> Thanks for help.
> 
> BR,
> Lionel

It's the CRC-32 of the 7-byte buffer "abcdefg" using an initial value of 0.
Bitwise little endian with a little endian digest, and no complementation at the
beginning or end.  Note that the initial value ("key") is not given explicitly,
i.e. this tests that the implementation uses the correct default initial value.

The generic, arm, and x86 implementations in the kernel obviously all pass this,
otherwise people would be complaining about them.  You can also verify it in
userspace with zlib using:

#include <assert.h>
#include <stdint.h>
#include <zlib.h>

int main()
{
        assert((uint32_t)~crc32(~0, "abcdefg", 7) == 0xac46b5d8);
}

(zlib complements the value at the beginning and end, so it must be undone to
match the kernel conversion which doesn't do that.)

- Eric
