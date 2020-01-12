Return-Path: <SRS0=5sH2=3B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208D0C32771
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jan 2020 06:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CE62082E
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jan 2020 06:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgALGkh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jan 2020 01:40:37 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:32104 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732282AbgALGkh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jan 2020 01:40:37 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jan 2020 01:40:36 EST
IronPort-SDR: ky94rd+KjmjaxB7RGMEAB1ah/5QZVzyrbzoPN9eRgtf1+lot0OSilRRrbsIjOnCo5bWNtvlS4c
 6xAp/u6iSWgA==
IronPort-PHdr: =?us-ascii?q?9a23=3AUJLVexBQKWbwuG1BcZGEUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSPTyocbcNUDSrc9gkEXOFd2Cra4d0KyM7f6rCDdIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfL1/IA+ooQjQt8Qajo9vJ6gswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwLMTk1/nzLhcNqiaJaoAutqgJ4w47OeIGVM+B+cbnBfdwEXG?=
 =?us-ascii?q?ZOQMBRWzVdD4Ogc4sAFfYOPeZGoIn4uVQOqwe+CRCyC+Pp0zNGgXj23ask3O?=
 =?us-ascii?q?UhCA3JwgogFM8KvHnasNn5KKIeXOaox6fK0DrDdetb1zn95ojSbB4vouyCUr?=
 =?us-ascii?q?1sfsTe0kQvCwHIgUmMpYD5Iz+ZyOIAuHWb4ep6UuKvjnYqpRtvrTiz2MgskJ?=
 =?us-ascii?q?TCiYISylDC+iVy3YE4JcWmR05nf9GkCpVRtyacN4t5Wc4iQ3potz0mxbEcpZ?=
 =?us-ascii?q?G7ey0KxI4nxx7ccvGKdZWD7BH7VOuJPzt0mXBodKiiixu87USs0PPwW8au3F?=
 =?us-ascii?q?tEridIlMTHuGoX2BzJ8MeHT+Nw/kKm2TmSyQ/e8vpEIUUolarDLJ4h36Iwmo?=
 =?us-ascii?q?ITsUvdGi/2n137jKqMeUUl/uio8froYrH6qpKTLYN0lAb+Pbk0lcyxBuQ4NB?=
 =?us-ascii?q?YBU3KF9uSnzLHj/Ev5T6tWjvAujKXVrZLXKd4GqqO3HwNZyJgv5hmlAzqo0N?=
 =?us-ascii?q?kUhXwHI0hEeBKDgYjpIVbOIPXgAPennVusjClkx+rIP73mBJXNIWPOkLf6fb?=
 =?us-ascii?q?lm90FQ0hY8zdda555OCrEBI+r/WlXtu9zAEh85Lwu0zv7jCNV80IMeRG2ODr?=
 =?us-ascii?q?aFP6PIsV6I/v4vI+6XaY8LtzbyNeIl6+TtjXAng18de7em3Z8NZHC/BPRmLB?=
 =?us-ascii?q?bRXX25htYHDHdPtRAvVPDtoEONXCQVZHuoWa84oDYhB9GcAJ/HV7yq1YSMwC?=
 =?us-ascii?q?qhVqJRYG8OXkiBDXryaIKCVPcPaDmYKedulzUFUf6qTIp3hj+0swqv87d7I/?=
 =?us-ascii?q?CcxSoeutq3zNVp6vfMkhc93TxvBc/b2GaICWF3yDBbDwQq1bxy9BUugmyI1r?=
 =?us-ascii?q?J11qcATdE=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2GeAgA1vRpelyMYgtlNGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBaAQBAQEBCwEBGwgBgSWBTVIgEpNQgU0fg0O?=
 =?us-ascii?q?LY4EAgx4VhgcUDIFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQE?=
 =?us-ascii?q?FBAEBAhABAQEBAQYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVO?=
 =?us-ascii?q?DBIJLAQEznXEBjQQNDQKFHYJKBAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ?=
 =?us-ascii?q?/ARIBbIJIglkEjUISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAO?=
 =?us-ascii?q?EToF9ozdXdAGBHnEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2GeAgA1vRpelyMYgtlNGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBaAQBAQEBCwEBGwgBgSWBTVIgEpNQgU0fg0OLY4EAgx4VhgcUD?=
 =?us-ascii?q?IFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQEFBAEBAhABAQEBA?=
 =?us-ascii?q?QYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVODBIJLAQEznXEBj?=
 =?us-ascii?q?QQNDQKFHYJKBAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARIBbIJIglkEj?=
 =?us-ascii?q?UISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF9ozdXdAGBH?=
 =?us-ascii?q?nEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,424,1571695200"; 
   d="scan'208";a="323228095"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 12 Jan 2020 07:35:33 +0100
Received: (qmail 24222 invoked from network); 12 Jan 2020 05:00:20 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 12 Jan 2020 05:00:20 -0000
Date:   Sun, 12 Jan 2020 06:00:18 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     linux-crypto@vger.kernel.org
Message-ID: <1572402.460728.1578805219919.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

