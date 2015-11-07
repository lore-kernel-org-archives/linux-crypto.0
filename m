From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH 1/7] A couple of generated files
Date: Sat, 7 Nov 2015 12:50:10 -0500
Message-ID: <CACXcFm=NamxxwwPR5Xok2HQMZx+4mMTEj0NvzwUHFDBWx39W+w@mail.gmail.com>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
	<20151107170104.GB29227@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts\\'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36641 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbbKGRuM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 12:50:12 -0500
In-Reply-To: <20151107170104.GB29227@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 7, 2015 at 12:01 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Sat, Nov 07, 2015 at 09:30:36AM -0500, Sandy Harris wrote:
>> Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
>> ---
>>  .gitignore | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/.gitignore b/.gitignore
>> index fd3a355..dd80bfd 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -112,3 +112,6 @@ all.config
>>
>>  # Kdevelop4
>>  *.kdev4
>> +
>> +certs/x509_certificate_list
>> +scripts/gen_random
>
> Is there a .gitignore file in scripts/ ?
>

Yes, though I wasn't aware of that.
I guess gen_random should be there instead of in the global file.
