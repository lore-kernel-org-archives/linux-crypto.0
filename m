From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 17:22:12 +0530
Message-ID: <CAFXBA==atCfmF53DTg0Yp6Q=K8GhtRy0HZzUG-bvzd5aVnfHuA@mail.gmail.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
	<3164476.NJZyJLbx96@tauon.atsec.com>
	<CAFXBA==PsTepbhPeBMsb1YyKx12B8ie5KC7VF=8pwCSBFJgfgg@mail.gmail.com>
	<14797179.fHPkmVmG4b@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33653 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbcEaLwO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 07:52:14 -0400
Received: by mail-oi0-f48.google.com with SMTP id k23so296573134oih.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 May 2016 04:52:13 -0700 (PDT)
In-Reply-To: <14797179.fHPkmVmG4b@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

1) User can use libkcapi to write program for finup/digest.
2) No, kernel test for finup (not sure).
3) We can test all callback of new hash tfm drivers added in kernel.
4) My driver had issue in finup path which is not caught by kcapi test
program :)

regards
Harsh Jain

regards
Harsh Jain

On Tue, May 31, 2016 at 4:35 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Dienstag, 31. Mai 2016, 16:28:14 schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Hi Stephen,
>>
>> Yes ,It's for Hash. The available API in library for hash update
>> "_kcapi_md_update" uses "MSG_MORE" flag always set. It will not
>> trigger driver's digest/finup implementation. We need something like
>> that
>>
>>  _kcapi_common_accept()
>> send(handle->opfd, buffer, len, 0); ==> flag = 0.
>>
>> It will execute digest callback of selected tfm from User
>> Space.(init->digest) Similarly
>>
>> _kcapi_common_accept()
>> send(handle->opfd, buffer, len, MSG_MORE);
>> send(handle->opfd, buffer, len, 0);
>>
>> It will execute finup callback of selected tfm. (init->update->finup).
>>
>> In that way we can test all callbacks from userspace. In future if you
>> feel this use case important. You can add API's to implement this.
>
> Ok, I see that the finup code path is not exercised in the kernel by my
> library.
>
> Why do you think that this code path should be tested by my test code?
>
> The test code shall verify that libkcapi works fine.
>
> Ciao
> Stephan
