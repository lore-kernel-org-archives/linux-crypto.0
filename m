Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF8CC46460
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5538B26871
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfEaLzL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:36409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfEaLzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from orion.localdomain ([77.7.63.28]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MJEEf-1hHdBC3Svb-00KdNB; Fri, 31 May 2019 13:54:57 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: RFC: get rid of #ifdef CONFIG_OF's around of match tables
Date:   Fri, 31 May 2019 13:54:47 +0200
Message-Id: <1559303690-8108-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:QyqpId/hEpcNLV2ZmI8NnMhtibn16SPodMQLXzILvjCTZujtrV0
 id2OuI9H+tP5hKxwdD5l4T12+FnVanAIAl+m6iiUrmT/gzMpFqZKiE5HWDI0pd9uXvJpQHX
 oGcrYHA2AD6dSGNqCdlkj1Or791Oiwv3BT2RNCEQRSxk7o5alVueZY65h2aMIYXC6BnhRl2
 zGIEtkognRBOEJZFCDh7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ru0tQEc/O7Y=:bqCnkg6fdTl1zAPWwfv2qw
 n+nRlkRnaiteuVAWA8xPgxfk0iCvdXr8CJKsNkhBbVv5JpIPxSZIzoHX73C9olkyLieKvhQhH
 kANXkHRrq5DVKPPVfrQ4C0ZBEL3JMoi/Zl8ij313RVCN7aoOTCHTJzSp+bu3Vjn8XRCeIKD0t
 6qLitUM3grDnC9S/zRWmFQf9BDG7ULvy+Zf9wcbRgeY5ix72TKDArTUyYx73/u498TZcbYz+g
 dcBu+MUn9WbTVNDra9txBbdPMIgstR0QR+Ujc33O8zVAIOOvXSk9HO+Yra/JmMsfFnYz9m0g9
 aJ8q6Gen4Qiw7dBRrZXdiXtEtHz6yQa5udCJqLxCJkW2OMjRzC0XB/Iys+CzSILg2rAe1h9xb
 VHT27GsOmhKoCjx6vCLkdFlqldl7knCdRs3YYi2v4Qwrj3KQDh30nrjfW9n0lwZfdMUBNNzRU
 BBH1tLpFnopr/lxS74F7Ukoa1TrF0cd5DiVz5YaBl+4dsO1PC47gR1KCVDhDu4B1jbfKRtnPX
 nQV6ZnwZljLhzZZd1lSdeCvAWQ0TLpdM3SlMCP6FZ8a3VjoYbem4HnqwxTCT+UuCb6h36ih0W
 lnrWlvcZ3DzgKg5kOBBnaLzDRYh1/AxAUWh6inICO/2wBuKEa6Nt2+GB6Afl04109edub0V0J
 ASjBavaB7nnHyx7NSMQa0BbMk9/wGVR0W2cp/JaMzMWBdugMMtjM4Q3ZuoHTWKjvww1jLZb+8
 JPT8svgsrcUydbrkqPsR2V3MJd8xdXIQN2JwSQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi folks,


we've got many places where code declaring oftree match tables is
enclodes by #ifdef CONFIG_OF, so it can also be built w/o oftree
support.

To make this easier to read, I'm proposing a new helper macro
MODULE_OF_TABLE(foo) which just calls MODULE_DEVICE_TABLE(of, foo)
when CONFIG_OF enabled, otherwise just noop. Along w/ of_match_ptr(),
we can get rid most of these #ifdef CONFIG_OF cases. I believe, the
compiler can automatically optimize-away the unused tables.
(correct me if I'm wrong)

This queue just introduces the macro and converts two random examples.
I'll post more patches for the rest of the tree, if you folks aggree
to this approach. And also I'd like to do the same w/ ACPI, PCI, etc.

Another idea I'm currently thinking about is moving the whole table
definition into a macro call, so the tables won't even get defined
when CONFIG_OF isn't defined, and we've got even less to type. It
then would look like this:

    MODULE_DECLARE_OF_MATCH(foo_of_match,
        { .compatible = "acme,foo" },
        { .compatible = "acme,bar" })

(note that the macro also defines the sentinel on its own).


What do you think about this idea ?


--mtx


